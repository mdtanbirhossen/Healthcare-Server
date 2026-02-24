/*
  Warnings:

  - You are about to drop the column `invoiceUrl` on the `payments` table. All the data in the column will be lost.
  - You are about to drop the column `pdfUrl` on the `prescriptions` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "payments" DROP COLUMN "invoiceUrl";

-- AlterTable
ALTER TABLE "prescriptions" DROP COLUMN "pdfUrl";
