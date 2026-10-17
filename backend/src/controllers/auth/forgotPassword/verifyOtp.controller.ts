import { Request, Response } from "express";
import { prisma } from "../../../lib/prisma.js";
import bcrypt from "bcrypt";


//controller to verify the otp sent through email
const verifyOtp = async (req: Request, res: Response) => {
    try {

        const { email: rawEmail, otp } = req.body;

        if(!rawEmail || !otp) {
            return res.status(409).json({
                success: false,
                message: "Email and otp is required"
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

        //find the latest unexpired otp 
        const otpRecord = await prisma.otp.findFirst({
            where: {
                userId: existingUser.id,
                used: false,
                expiresAt: {
                    gt: new Date()
                }
            },
            orderBy: {
                createdAt: "desc"
            }
        });

        if (!otpRecord) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }

        //check if otp is valid or not
        const isOtpValid = await bcrypt.compare(otp, otpRecord.otpHash);

        if (!isOtpValid) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }

        //mark otp as used
        const result = await prisma.otp.updateMany({
            where: {
                id: otpRecord.id,
                used: false,
                expiresAt: {
                    gt: new Date()
                }
            },
            data: {
                used: true
            }
        });

        if (result.count !== 1) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }


        return res.status(200).json({
            success: true,
            message: "OTP verified successfully",
        });


        
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
}

export default verifyOtp;