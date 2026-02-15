import express, { Application, NextFunction, Request, Response } from "express";
import { IndexRoutes } from "./app/routes";
import cookieParser from "cookie-parser";
import { globalErrorHandler } from "./app/middleware/globalErrorHandler";
import { notFound } from "./app/middleware/notFound";
import { toNodeHandler } from "better-auth/node";
import { auth } from "./app/lib/auth";
import path from "path";

const app: Application = express();

app.set("view engine", "ejs");
app.set("views", path.resolve(process.cwd(), `src/app/templates`));

app.use("/api/auth", toNodeHandler(auth));
// Enable URL-encoded form data parsing

app.use(express.urlencoded({ extended: true }));

// Middleware to parse JSON bodies
app.use(express.json());
app.use(cookieParser());

app.use("/api/v1", IndexRoutes);

// Basic route
app.get("/", (req: Request, res: Response) => {
    // throw new AppError(status.BAD_REQUEST,"Just testing error handler")
    res.send("Hello, TypeScript + Express!");
});

app.use(globalErrorHandler);
app.use(notFound);

export default app;
