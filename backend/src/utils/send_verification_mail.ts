import nodemailer from "nodemailer";

const tranporter = nodemailer.createTransport(
    {
        secure: true,
        host: "smtp.gmail.com",
        port: 465,
        auth: {
            user: "gullurajput18@gmail.com",
            pass: "brofislqtqsfhtty"
        }
    }
);

const sendMail = (to: string, otp: string) => {
    tranporter.sendMail({
        to: to,
        subject: "Kotobo email verification code",
        html: `Your verification otp for Kotobo japanese learning application is: ${otp}`
    });
}

export default sendMail;