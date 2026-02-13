-- CreateTable
CREATE TABLE "levels" (
    "level_id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "placement" INTEGER NOT NULL,
    "moderation" BOOLEAN NOT NULL DEFAULT false,
    "public" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "levels_pkey" PRIMARY KEY ("level_id")
);

-- CreateTable
CREATE TABLE "users" (
    "user_id" SERIAL NOT NULL,
    "username" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "vote_types" (
    "vote_type_id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "weight" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "vote_types_pkey" PRIMARY KEY ("vote_type_id")
);

-- CreateTable
CREATE TABLE "votes" (
    "user_id" INTEGER NOT NULL,
    "level_id" INTEGER NOT NULL,
    "vote_type_id" INTEGER NOT NULL,
    "voted_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "votes_pkey" PRIMARY KEY ("user_id","level_id")
);

-- CreateTable
CREATE TABLE "comments" (
    "comment_id" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER NOT NULL,
    "level_id" INTEGER NOT NULL,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("comment_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "vote_types_name_key" ON "vote_types"("name");

-- AddForeignKey
ALTER TABLE "votes" ADD CONSTRAINT "fk_vote_level" FOREIGN KEY ("level_id") REFERENCES "levels"("level_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "votes" ADD CONSTRAINT "fk_vote_type" FOREIGN KEY ("vote_type_id") REFERENCES "vote_types"("vote_type_id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "votes" ADD CONSTRAINT "fk_vote_user" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_level_id_fkey" FOREIGN KEY ("level_id") REFERENCES "levels"("level_id") ON DELETE CASCADE ON UPDATE CASCADE;
