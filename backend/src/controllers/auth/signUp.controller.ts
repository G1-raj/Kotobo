import { Request, Response } from "express";
import { prisma } from "../../lib/prisma.js";
import bcrypt from "bcrypt";

//signUp controller to create a new account
const signUp = async (req: Request, res: Response) => {
    try {

        const { email: rawEmail, username, password } = req.body;

        //verifying if all the credentials are present or not to create a user
        if(!rawEmail || !username ||!password) {
            return res.status(400).json({
                success: false,
                message: "Invalid signup details"
            });
        }

        const email = rawEmail.trim().toLowerCase();

        //checking password length
        if(password.length < 8) {
            return res.status(400).json({
                success: false,
                message: "Password must be atleast 8 characters"
            });
        }

        //checking if user already exist or not 
        const userExist = await prisma.user.findUnique({
            where: {
                email: email
            }
        });

        if (userExist) {
            return res.status(409).json({
                success: false,
                message: "User already exist"
            });
        }

        //hashing the password
        const hashedPassword = await bcrypt.hash(password, 10);

        //creating user 
        const user = await prisma.user.create({
            data: {
                email: email,
                username: username,
                password: hashedPassword
            }, 
            select: {
                id: true,
                email: true,
                username: true,
                createdAt: true,
                updatedAt: true
            }
        });

        //response
        return res.status(201).json({
            success: true,
            data: user,
            message: "User created successfully"
        });

        
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error"
        })
    }
}

export default signUp;