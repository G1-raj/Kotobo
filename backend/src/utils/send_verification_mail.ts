import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport(
    {
        secure: true,
        host: "smtp.gmail.com",
        port: 465,
        auth: {
            user: process.env.GMAIL_USER,
            pass: process.env.GMAIL_APP_PASSWORD
        }
    }
);

const sendMail = async (to: string, otp: string): Promise<void> => {
    await transporter.sendMail({
        from: `"Kotobo" <${process.env.GMAIL_USER}>`,
        to,
        subject: "Kotobo email verification code",
        text: `Your Kotobo verification code is ${otp}. It expires in 15 minutes.`,
        html: `
            <div style="font-family: Arial, sans-serif;">
                <h2>Kotobo Email Verification</h2>
                <p>Your verification code is:</p>
                <h1 style="letter-spacing: 5px;">${otp}</h1>
                <p>This code expires in 15 minutes.</p>
                <p>If you did not request this code, you can ignore this email.</p>
            </div>
        `,
    });
};

export default sendMail;