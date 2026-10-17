import { Request, Response } from "express";
import { prisma } from "../../../lib/prisma.js";
import generateOtp from "../../../utils/generateOtp.js";
import bcrypt from "bcrypt";
import sendMail from "../../../utils/send_verification_mail.js";

//controller to send otp for resetting the password
const sendOtp = async (req: Request, res: Response) => {
    try {

        const { email: rawEmail } = req.body;

        if(!rawEmail) {
            return res.status(409).json({
                success: false,
                message: "Email is required"
            });
        }

        const email = rawEmail.trim().toLowerCase();

        //check if user exist or not
        const existingUser = await prisma.user.findUnique({
            where: {
                email: email
            }
        });

        if(!existingUser) {
            return res.status(404).json({
                success: false,
                message: "User does not exist"
            });
        }

        //generating otp
        const otp = generateOtp();
        const hashedOtp = await bcrypt.hash(otp, 10);

        //storing the otp with expiry on database
        await prisma.otp.create({
            data: {
                userId: existingUser.id,
                otpHash: hashedOtp,
                expiresAt: new Date(Date.now() + 15 * 60 * 1000),
            }
        });

        //sending the otp to user through email
        await sendMail(existingUser.email, otp);

        return res.status(201).json({
            success: true,
            message: "Otp sent successfully"
        });
        
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
}

export default sendOtp;

