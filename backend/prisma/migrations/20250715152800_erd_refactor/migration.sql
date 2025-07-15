-- CreateTable
CREATE TABLE "company" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,

    CONSTRAINT "company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "position" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) NOT NULL,
    "is_visible" BOOLEAN NOT NULL DEFAULT true,
    "location" VARCHAR(100),
    "job_description" TEXT,
    "requirements" TEXT,
    "responsibilities" TEXT,
    "salary_min" DECIMAL(65,30),
    "salary_max" DECIMAL(65,30),
    "employment_type" VARCHAR(50),
    "benefits" TEXT,
    "company_description" TEXT,
    "application_deadline" DATE,
    "contact_info" VARCHAR(255),

    CONSTRAINT "position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_flow" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,

    CONSTRAINT "interview_flow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_step" (
    "id" SERIAL NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "order_index" INTEGER NOT NULL,

    CONSTRAINT "interview_step_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_type" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,

    CONSTRAINT "interview_type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "candidate" (
    "id" SERIAL NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(20),
    "address" VARCHAR(255),

    CONSTRAINT "candidate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "application" (
    "id" SERIAL NOT NULL,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" DATE NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "application_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview" (
    "id" SERIAL NOT NULL,
    "application_id" INTEGER NOT NULL,
    "interview_step_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "interview_date" DATE NOT NULL,
    "result" VARCHAR(50),
    "score" INTEGER,
    "notes" TEXT,

    CONSTRAINT "interview_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "employee_email_key" ON "employee"("email");

-- CreateIndex
CREATE INDEX "employee_company_id_idx" ON "employee"("company_id");

-- CreateIndex
CREATE INDEX "employee_email_idx" ON "employee"("email");

-- CreateIndex
CREATE INDEX "position_company_id_idx" ON "position"("company_id");

-- CreateIndex
CREATE INDEX "position_interview_flow_id_idx" ON "position"("interview_flow_id");

-- CreateIndex
CREATE INDEX "position_status_idx" ON "position"("status");

-- CreateIndex
CREATE INDEX "interview_step_interview_flow_id_idx" ON "interview_step"("interview_flow_id");

-- CreateIndex
CREATE INDEX "interview_step_interview_type_id_idx" ON "interview_step"("interview_type_id");

-- CreateIndex
CREATE UNIQUE INDEX "candidate_email_key" ON "candidate"("email");

-- CreateIndex
CREATE INDEX "candidate_email_idx" ON "candidate"("email");

-- CreateIndex
CREATE INDEX "application_position_id_idx" ON "application"("position_id");

-- CreateIndex
CREATE INDEX "application_candidate_id_idx" ON "application"("candidate_id");

-- CreateIndex
CREATE INDEX "application_status_idx" ON "application"("status");

-- CreateIndex
CREATE INDEX "application_application_date_idx" ON "application"("application_date");

-- CreateIndex
CREATE INDEX "interview_application_id_idx" ON "interview"("application_id");

-- CreateIndex
CREATE INDEX "interview_interview_step_id_idx" ON "interview"("interview_step_id");

-- CreateIndex
CREATE INDEX "interview_employee_id_idx" ON "interview"("employee_id");

-- CreateIndex
CREATE INDEX "interview_interview_date_idx" ON "interview"("interview_date");

-- AddForeignKey
ALTER TABLE "employee" ADD CONSTRAINT "employee_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "interview_flow"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_step" ADD CONSTRAINT "interview_step_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "interview_flow"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_step" ADD CONSTRAINT "interview_step_interview_type_id_fkey" FOREIGN KEY ("interview_type_id") REFERENCES "interview_type"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application" ADD CONSTRAINT "application_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application" ADD CONSTRAINT "application_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview" ADD CONSTRAINT "interview_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview" ADD CONSTRAINT "interview_interview_step_id_fkey" FOREIGN KEY ("interview_step_id") REFERENCES "interview_step"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview" ADD CONSTRAINT "interview_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
