import { auth } from "../../lib/auth";
import { prisma } from "../../lib/prisma";
interface IRegisterPatientPayload {
  name: string;
  email: string;
  password: string;
}
const registerPatient = async (payload: IRegisterPatientPayload) => {
  const { name, email, password } = payload;
  const data = await auth.api.signUpEmail({
    body: {
      name,
      email,
      password,
    },
  });

  if (!data.user) {
    throw new Error("Failed to register patient!");
  }
  console.log(data);

  //   TODO: create patient profile in transaction after signup of patient in user model
  try {
    const patient = await prisma.$transaction(async (tx) => {
      const patientTx = await tx.patient.create({
        data: {
          userId: data.user.id,
          name: payload.name,
          email: payload.email,
        },
      });
      return patientTx;
    });
    return {
      ...data,
      patient,
    };
  } catch (error) {
    console.log("transaction error: ", error);
    await prisma.user.delete({
      where:{
        id:data.user.id
      }
    })
    throw error;
  }
};

interface ILoginUser {
  email: string;
  password: string;
}

const loginUser = async (payload: ILoginUser) => {
  const { email, password } = payload;
  const data = await auth.api.signInEmail({
    body: {
      email,
      password,
    },
  });
  console.log(data);
  return data;
};

export const AuthService = {
  registerPatient,
  loginUser,
};
