import status from "http-status";
import { Specialty } from "../../../generated/prisma/client";
import AppError from "../../errorHelpers/AppError";
import { prisma } from "../../lib/prisma";

const createSpecialty = async (payload: Specialty): Promise<Specialty> => {
    const specialty = await prisma.specialty.create({
        data: payload,
    });
    return specialty;
};

const getAllSpecialties = async () => {
    const specialties = await prisma.specialty.findMany();
    return specialties;
};

const getSpecialtyById = async (id: string) => {
    const specialty = await prisma.specialty.findFirst({
        where: { id },
    });
    if (!specialty) {
        throw new AppError(status.NOT_FOUND, "Specialty not found");
    }
    return specialty;
};

const updateSpecialtyById = async (
    id: string,
    payload: Partial<Specialty>,
): Promise<Specialty> => {
    const specialty = await prisma.specialty.update({
        where: { id },
        data: payload,
    });
    return specialty;
};

const deleteSpecialty = async (id: string) => {
    const specialty = await prisma.specialty.delete({
        where: { id },
    });
    return specialty;
};

export const SpecialtyService = {
    createSpecialty,
    getAllSpecialties,
    deleteSpecialty,
    getSpecialtyById,
    updateSpecialtyById,
};
