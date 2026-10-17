import { Request, Response } from "express";
import { prisma } from "../../lib/prisma.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";


//Login controller for user login
const logIn = async (req: Request, res: Response) => {
    try {

        const { email: rawEmail, password } = req.body;

        //verifying if all the credentials are present or not to create a user
        if(!rawEmail || !password) {
            return res.status(409).json({
                success: false,
                message: "Invalid login details"
            });
        }
        
        const email = rawEmail.trim().toLowerCase();


        //checking if user already exist or not 
        const existingUser = await prisma.user.findUnique({
            where: {
                email: email
            }
        });

        if(!existingUser) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        //validating password
        const validPassword = await bcrypt.compare(password, existingUser.password);

        if(!validPassword) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        const jwtSecret = process.env.JWT_SECRET;
        const refreshSecret = process.env.REFRESH_TOKEN_SECRET;

        if(!jwtSecret || !refreshSecret) {
            throw Error("Jwt secrets are missing");
        }

        //payload for jwt
        const payload = {
            id: existingUser.id,
            email: existingUser.email,
        };

        //creating short life access token
        const accessToken = jwt.sign(payload, jwtSecret, { expiresIn: '15m', algorithm: 'HS256' });
        //creating long life refresh token
        const refreshToken = jwt.sign(payload, refreshSecret, { expiresIn: '7d', algorithm: 'HS256' });

        //hashing the refresh token
        const refreshTokenHash = await bcrypt.hash(refreshToken, 10);

        //storing hashed refresh token on database
        await prisma.session.create({
            data: {
                refreshToken: refreshTokenHash,
                userId: existingUser.id,
                expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
            }
        });

        //sending and saving the refreshtoken in cookie
        res.cookie("refreshToken", refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === "production",
            sameSite: "strict",
            path: "/",
            maxAge: 7 * 24 * 60 * 60 * 1000,
        });

        //creating user response with all the valid fields
        const user = {
            id: existingUser.id,
            email: existingUser.email,
            username: existingUser.username,
            accessToken: accessToken,
            createdAt: existingUser.createdAt,
            updatedAt: existingUser.updatedAt
        };


        //success response
        return res.status(200).json({
            success: true,
            data: user,
            message: "User login successful"
        });

        
        
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
}

export default logIn;