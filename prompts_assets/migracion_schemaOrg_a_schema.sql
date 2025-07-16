-- Tabla nueva: Application
CREATE TABLE application (
  id               Int         -- @id -- @default(autoincrement()),
  positionId       Int,
  candidateId      Int,
  applicationDate  DateTime?   -- @db.Date,
  status           String?     -- @db.VarChar(50),
  notes            String?,
  candidate        Candidate   -- @relation(fields: [candidateId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  position         Position    -- @relation(fields: [positionId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  interviews       Interview[]
);


-- Tabla nueva: Company
CREATE TABLE company (
  id       Int        -- @id -- @default(autoincrement()),
  name     String     -- @db.VarChar(255),
  employees Employee[],
  positions Position[]
);


-- Tabla nueva: Employee
CREATE TABLE employee (
  id         Int         -- @id -- @default(autoincrement()),
  companyId  Int,
  name       String      -- @db.VarChar(255),
  email      String      -- @unique -- @db.VarChar(255),
  role       String?     -- @db.VarChar(100),
  isActive   Boolean?    -- @default(true),
  company    Company     -- @relation(fields: [companyId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  interviews Interview[]
);


-- Tabla nueva: Interview
CREATE TABLE interview (
  id                Int            -- @id -- @default(autoincrement()),
  applicationId     Int,
  interviewStepId   Int,
  employeeId        Int,
  interviewDate     DateTime?      -- @db.Date,
  result            String?        -- @db.VarChar(50),
  score             Int?,
  notes             String?,
  application       Application    -- @relation(fields: [applicationId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  employee          Employee       -- @relation(fields: [employeeId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  interviewStep     InterviewStep  -- @relation(fields: [interviewStepId], references: [id], onDelete: NoAction, onUpdate: NoAction)
);


-- Tabla nueva: InterviewFlow
CREATE TABLE interviewflow (
  id             Int              -- @id -- @default(autoincrement()),
  description    String?          -- @db.VarChar(255),
  interviewSteps InterviewStep[],
  positions      Position[]
);


-- Tabla nueva: InterviewStep
CREATE TABLE interviewstep (
  id                Int            -- @id -- @default(autoincrement()),
  interviewFlowId   Int,
  interviewTypeId   Int,
  name              String?        -- @db.VarChar(255),
  orderIndex        Int?,
  interviews        Interview[],
  interviewFlow     InterviewFlow  -- @relation(fields: [interviewFlowId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  interviewType     InterviewType  -- @relation(fields: [interviewTypeId], references: [id], onDelete: NoAction, onUpdate: NoAction)
);


-- Tabla nueva: InterviewType
CREATE TABLE interviewtype (
  id             Int              -- @id -- @default(autoincrement()),
  name           String           -- @db.VarChar(100),
  description    String?,
  interviewSteps InterviewStep[]
);


-- Tabla nueva: Position
CREATE TABLE position (
  id                   Int            -- @id -- @default(autoincrement()),
  companyId            Int,
  interviewFlowId      Int,
  title                String?        -- @db.VarChar(255),
  description          String?,
  status               String?        -- @db.VarChar(50),
  isVisible            Boolean?       -- @default(true),
  location             String?        -- @db.VarChar(255),
  jobDescription       String?,
  requirements         String?,
  responsibilities     String?,
  salaryMin            Decimal?       -- @db.Decimal(12, 2),
  salaryMax            Decimal?       -- @db.Decimal(12, 2),
  employmentType       String?        -- @db.VarChar(50),
  benefits             String?,
  companyDescription   String?,
  applicationDeadline  DateTime?      -- @db.Date,
  contactInfo          String?        -- @db.VarChar(255),
  applications         Application[],
  company              Company        -- @relation(fields: [companyId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  interviewFlow        InterviewFlow  -- @relation(fields: [interviewFlowId], references: [id], onDelete: NoAction, onUpdate: NoAction),
  skills               PositionSkill[]
);


-- Tabla nueva: Institution
CREATE TABLE institution (
  id         Int         -- @id -- @default(autoincrement()),
  name       String      -- @unique -- @db.VarChar(100),
  educations Education[]
);


-- Tabla nueva: JobTitle
CREATE TABLE jobtitle (
  id              Int              -- @id -- @default(autoincrement()),
  name            String           -- @unique -- @db.VarChar(150),
  educations      Education[],
  workExperiences WorkExperience[]
);


-- Tabla nueva: Location
CREATE TABLE location (
  id       Int       -- @id -- @default(autoincrement()),
  name     String    -- @unique -- @db.VarChar(100),
  resumes  Resume[]
);


-- Tabla nueva: Skill
CREATE TABLE skill (
  id       Int       -- @id -- @default(autoincrement()),
  name     String    -- @unique -- @db.VarChar(100),
  resumes  ResumeSkill[],
  positions PositionSkill[]
);


-- Tabla nueva: Language
CREATE TABLE language (
  id       Int       -- @id -- @default(autoincrement()),
  name     String    -- @unique -- @db.VarChar(100),
  resumes  ResumeLanguage[]
);


-- Tabla nueva: ResumeSkill
CREATE TABLE resumeskill (
  resumeId Int,
  skillId  Int,
  resume   Resume -- @relation(fields: [resumeId], references: [id]),
  skill    Skill  -- @relation(fields: [skillId], references: [id])
);


-- Tabla nueva: ResumeLanguage
CREATE TABLE resumelanguage (
  resumeId   Int,
  languageId Int,
  resume     Resume   -- @relation(fields: [resumeId], references: [id]),
  language   Language -- @relation(fields: [languageId], references: [id])
);


-- Tabla nueva: PositionSkill
CREATE TABLE positionskill (
  positionId Int,
  skillId    Int,
  position   Position -- @relation(fields: [positionId], references: [id]),
  skill      Skill    -- @relation(fields: [skillId], references: [id])
);


-- Tabla nueva: Career
CREATE TABLE career (
  id         Int         -- @id -- @default(autoincrement()),
  name       String      -- @unique,
  candidates Candidate[]
);


-- Nuevo campo en Candidate: career
ALTER TABLE candidate ADD COLUMN career INTEGER /* FK or unknown type */;

-- Nuevo campo en Candidate: careerId
ALTER TABLE candidate ADD COLUMN careerId INTEGER;

-- Nuevo campo en Candidate: applications
ALTER TABLE candidate ADD COLUMN applications INTEGER /* FK or unknown type */;

-- Nuevo campo en Education: jobTitle
ALTER TABLE education ADD COLUMN jobTitle INTEGER /* FK or unknown type */;

-- Nuevo campo en Education: id
ALTER TABLE education ADD COLUMN id INTEGER;

-- Nuevo campo en Education: institutionId
ALTER TABLE education ADD COLUMN institutionId INTEGER;

-- Nuevo campo en Education: institution
ALTER TABLE education ADD COLUMN institution INTEGER /* FK or unknown type */;

-- Nuevo campo en Education: candidate
ALTER TABLE education ADD COLUMN candidate INTEGER /* FK or unknown type */;

-- Nuevo campo en Education: jobTitleId
ALTER TABLE education ADD COLUMN jobTitleId INTEGER;

-- Nuevo campo en WorkExperience: jobTitleId
ALTER TABLE workexperience ADD COLUMN jobTitleId INTEGER;

-- Nuevo campo en WorkExperience: jobTitle
ALTER TABLE workexperience ADD COLUMN jobTitle INTEGER /* FK or unknown type */;

-- Nuevo campo en Resume: location
ALTER TABLE resume ADD COLUMN location INTEGER /* FK or unknown type */;

-- Nuevo campo en Resume: locationId
ALTER TABLE resume ADD COLUMN locationId INTEGER;

-- Nuevo campo en Resume: languages
ALTER TABLE resume ADD COLUMN languages INTEGER /* FK or unknown type */;

-- Nuevo campo en Resume: skills
ALTER TABLE resume ADD COLUMN skills INTEGER /* FK or unknown type */;