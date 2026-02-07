import { auth } from "../../lib/auth";
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

  return data;
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
  console.log(data)
  return data;
};

export const AuthService = {
  registerPatient,
  loginUser,
};
