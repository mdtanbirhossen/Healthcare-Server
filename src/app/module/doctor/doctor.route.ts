import { Router } from "express";
import { DoctorController } from "./doctor.controller";

const router = Router();

router.get("/", DoctorController.getAllDoctors);

// todo: get doctor by id
// todo: update doctor
// todo soft delete doctor

export const DoctorRoutes = router;
