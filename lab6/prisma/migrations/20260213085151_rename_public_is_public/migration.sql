/*
  Warnings:

  - You are about to drop the column `public` on the `levels` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "levels" DROP COLUMN "public",
ADD COLUMN     "isPublic" BOOLEAN NOT NULL DEFAULT true;
