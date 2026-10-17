import { Request, Response } from "express";
import { prisma } from "../../../lib/prisma.js";
import bcrypt from "bcrypt";

const changePassword = async (req: Request, res: Response) => {
    try {

        const { email: rawEmail, password } = req.body;

        if(!rawEmail || !password) {
            return res.status(409).json({
                success: false,
                message: "Invalid details for resetting the password"
            });
        }

        const email = rawEmail.trim().toLowerCase();

        //find user
        const user = await prisma.user.findUnique({
            where: {
                email: email
            }
        });

        //notify user that user does not exist
        if(!user) {
            return res.status(404).json({
                success: false,
                message: "User does not exist"
            });
        }

        //hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        //save new password
        const updatedUser = await prisma.user.update({
            where: {
                email: email
            },
            data: {
                password: hashedPassword
            }
        });

        const userCredentials = {
            id: updatedUser.id,
            email: updatedUser.email,
            username: updatedUser.username,
            createdAt: updatedUser.createdAt,
            updatedAt: updatedUser.updatedAt
        }

        res.status(200).json({
            success: true,
            data: userCredentials,
            message: "Password changed successfully"
        });
        
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
}

export default changePassword;