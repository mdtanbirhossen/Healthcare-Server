/*
  Warnings:

  - The values [IN_PROGRESS] on the enum `AppointmentStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the `admin` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[videoCallingId]` on the table `appointments` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[stripeEventId]` on the table `payments` will be added. If there are existing duplicate values, this will fail.
  - Changed the type of `videoCallingId` on the `appointments` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `transactionId` on the `payments` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "AppointmentStatus_new" AS ENUM ('SCHEDULED', 'INPROGRESS', 'COMPLETED', 'CANCELED');
ALTER TABLE "public"."appointments" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "appointments" ALTER COLUMN "status" TYPE "AppointmentStatus_new" USING ("status"::text::"AppointmentStatus_new");
ALTER TYPE "AppointmentStatus" RENAME TO "AppointmentStatus_old";
ALTER TYPE "AppointmentStatus_new" RENAME TO "AppointmentStatus";
DROP TYPE "public"."AppointmentStatus_old";
ALTER TABLE "appointments" ALTER COLUMN "status" SET DEFAULT 'SCHEDULED';
COMMIT;

-- DropForeignKey
ALTER TABLE "admin" DROP CONSTRAINT "admin_userId_fkey";

-- AlterTable
ALTER TABLE "appointments" DROP COLUMN "videoCallingId",
ADD COLUMN     "videoCallingId" UUID NOT NULL;

-- AlterTable
ALTER TABLE "payments" ADD COLUMN     "invoiceUrl" TEXT,
ADD COLUMN     "stripeEventId" TEXT,
DROP COLUMN "transactionId",
ADD COLUMN     "transactionId" UUID NOT NULL;

-- AlterTable
ALTER TABLE "prescriptions" ADD COLUMN     "pdfUrl" TEXT;

-- DropTable
DROP TABLE "admin";

-- DropEnum
DROP TYPE "MaritalStatus";

-- CreateTable
CREATE TABLE "admins" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "profilePhoto" TEXT,
    "contactNumber" TEXT,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "userId" TEXT NOT NULL,

    CONSTRAINT "admins_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "admins_email_key" ON "admins"("email");

-- CreateIndex
CREATE UNIQUE INDEX "admins_userId_key" ON "admins"("userId");

-- CreateIndex
CREATE INDEX "admins_email_idx" ON "admins"("email");

-- CreateIndex
CREATE INDEX "admins_isDeleted_idx" ON "admins"("isDeleted");

-- CreateIndex
CREATE UNIQUE INDEX "appointments_videoCallingId_key" ON "appointments"("videoCallingId");

-- CreateIndex
CREATE UNIQUE INDEX "payments_transactionId_key" ON "payments"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "payments_stripeEventId_key" ON "payments"("stripeEventId");

-- CreateIndex
CREATE INDEX "payments_transactionId_idx" ON "payments"("transactionId");

-- AddForeignKey
ALTER TABLE "admins" ADD CONSTRAINT "admins_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- RenameIndex
ALTER INDEX "idx_doctor_specialty_doctor_id" RENAME TO "idx_doctor_specialty_doctorId";

-- RenameIndex
ALTER INDEX "idx_doctor_specialty_specialty_id" RENAME TO "idx_doctor_specialty_specialtyId";
