import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');

  // Clean existing data (optional - be careful in production)
  // await prisma.interview.deleteMany();
  // await prisma.application.deleteMany();
  // await prisma.candidate.deleteMany();
  // await prisma.position.deleteMany();
  // await prisma.interviewStep.deleteMany();
  // await prisma.interviewFlow.deleteMany();
  // await prisma.interviewType.deleteMany();
  // await prisma.employee.deleteMany();
  // await prisma.company.deleteMany();

  // ============================================================================
  // 1. Companies
  // ============================================================================
  console.log('Creating companies...');
  const company1 = await prisma.company.create({
    data: {
      name: 'TechCorp Solutions',
    },
  });

  const company2 = await prisma.company.create({
    data: {
      name: 'InnovateHub Inc.',
    },
  });

  console.log(`✅ Created ${2} companies`);

  // ============================================================================
  // 2. Employees
  // ============================================================================
  console.log('Creating employees...');
  const employee1 = await prisma.employee.create({
    data: {
      companyId: company1.id,
      name: 'John Smith',
      email: 'john.smith@techcorp.com',
      role: 'Senior Recruiter',
      isActive: true,
    },
  });

  const employee2 = await prisma.employee.create({
    data: {
      companyId: company1.id,
      name: 'Sarah Johnson',
      email: 'sarah.johnson@techcorp.com',
      role: 'Technical Interviewer',
      isActive: true,
    },
  });

  const employee3 = await prisma.employee.create({
    data: {
      companyId: company2.id,
      name: 'Michael Chen',
      email: 'michael.chen@innovatehub.com',
      role: 'HR Manager',
      isActive: true,
    },
  });

  const employee4 = await prisma.employee.create({
    data: {
      companyId: company2.id,
      name: 'Emily Davis',
      email: 'emily.davis@innovatehub.com',
      role: 'Lead Engineer',
      isActive: true,
    },
  });

  console.log(`✅ Created ${4} employees`);

  // ============================================================================
  // 3. Interview Types
  // ============================================================================
  console.log('Creating interview types...');
  const interviewType1 = await prisma.interviewType.create({
    data: {
      name: 'Phone Screen',
      description: 'Initial phone screening interview',
    },
  });

  const interviewType2 = await prisma.interviewType.create({
    data: {
      name: 'Technical Interview',
      description: 'Technical skills assessment interview',
    },
  });

  const interviewType3 = await prisma.interviewType.create({
    data: {
      name: 'HR Interview',
      description: 'Human resources and cultural fit interview',
    },
  });

  const interviewType4 = await prisma.interviewType.create({
    data: {
      name: 'Final Round',
      description: 'Final round interview with management',
    },
  });

  console.log(`✅ Created ${4} interview types`);

  // ============================================================================
  // 4. Interview Flows
  // ============================================================================
  console.log('Creating interview flows...');
  const flow1 = await prisma.interviewFlow.create({
    data: {
      description: 'Standard Engineering Flow',
    },
  });

  const flow2 = await prisma.interviewFlow.create({
    data: {
      description: 'Executive Position Flow',
    },
  });

  console.log(`✅ Created ${2} interview flows`);

  // ============================================================================
  // 5. Interview Steps
  // ============================================================================
  console.log('Creating interview steps...');
  // Flow 1: Standard Engineering Flow (4 steps)
  const step1_1 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow1.id,
      interviewTypeId: interviewType1.id,
      name: 'Initial Phone Screen',
      orderIndex: 1,
    },
  });

  const step1_2 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow1.id,
      interviewTypeId: interviewType2.id,
      name: 'Technical Assessment',
      orderIndex: 2,
    },
  });

  const step1_3 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow1.id,
      interviewTypeId: interviewType3.id,
      name: 'HR Cultural Fit',
      orderIndex: 3,
    },
  });

  const step1_4 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow1.id,
      interviewTypeId: interviewType4.id,
      name: 'Final Manager Interview',
      orderIndex: 4,
    },
  });

  // Flow 2: Executive Position Flow (3 steps)
  const step2_1 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow2.id,
      interviewTypeId: interviewType1.id,
      name: 'Executive Phone Screen',
      orderIndex: 1,
    },
  });

  const step2_2 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow2.id,
      interviewTypeId: interviewType3.id,
      name: 'Board Interview',
      orderIndex: 2,
    },
  });

  const step2_3 = await prisma.interviewStep.create({
    data: {
      interviewFlowId: flow2.id,
      interviewTypeId: interviewType4.id,
      name: 'CEO Final Interview',
      orderIndex: 3,
    },
  });

  console.log(`✅ Created ${7} interview steps`);

  // ============================================================================
  // 6. Positions
  // ============================================================================
  console.log('Creating positions...');
  const position1 = await prisma.position.create({
    data: {
      companyId: company1.id,
      interviewFlowId: flow1.id,
      title: 'Senior Full Stack Developer',
      description: 'We are looking for an experienced full stack developer',
      status: 'open',
      isVisible: true,
      location: 'San Francisco, CA',
      jobDescription: 'Join our team to build cutting-edge web applications',
      requirements: '5+ years experience, React, Node.js, PostgreSQL',
      responsibilities: 'Design and implement features, code reviews, mentor juniors',
      salaryMin: 120000,
      salaryMax: 160000,
      employmentType: 'full-time',
      benefits: 'Health insurance, 401k, remote work options',
      companyDescription: 'TechCorp is a leading technology company',
      applicationDeadline: new Date('2024-12-31'),
      contactInfo: 'careers@techcorp.com',
    },
  });

  const position2 = await prisma.position.create({
    data: {
      companyId: company1.id,
      interviewFlowId: flow1.id,
      title: 'Frontend Developer',
      description: 'Frontend developer position',
      status: 'open',
      isVisible: true,
      location: 'Remote',
      jobDescription: 'Build beautiful user interfaces',
      requirements: '3+ years React, TypeScript, CSS',
      responsibilities: 'UI/UX implementation, component library',
      salaryMin: 90000,
      salaryMax: 120000,
      employmentType: 'full-time',
      benefits: 'Full remote, flexible hours',
      companyDescription: 'TechCorp Solutions',
      applicationDeadline: new Date('2024-11-30'),
      contactInfo: 'jobs@techcorp.com',
    },
  });

  const position3 = await prisma.position.create({
    data: {
      companyId: company2.id,
      interviewFlowId: flow2.id,
      title: 'Chief Technology Officer',
      description: 'CTO position for growing startup',
      status: 'open',
      isVisible: true,
      location: 'New York, NY',
      jobDescription: 'Lead technology strategy and engineering teams',
      requirements: '10+ years experience, leadership, technical expertise',
      responsibilities: 'Technology vision, team leadership, architecture',
      salaryMin: 200000,
      salaryMax: 300000,
      employmentType: 'full-time',
      benefits: 'Equity, executive benefits package',
      companyDescription: 'InnovateHub is a fast-growing tech startup',
      applicationDeadline: new Date('2024-10-31'),
      contactInfo: 'executive@innovatehub.com',
    },
  });

  const position4 = await prisma.position.create({
    data: {
      companyId: company2.id,
      interviewFlowId: flow1.id,
      title: 'Backend Developer',
      description: 'Backend developer position',
      status: 'draft',
      isVisible: false,
      location: 'Austin, TX',
      jobDescription: 'Build scalable backend systems',
      requirements: 'Node.js, PostgreSQL, AWS',
      responsibilities: 'API development, database design',
      salaryMin: 100000,
      salaryMax: 140000,
      employmentType: 'full-time',
      benefits: 'Health, dental, vision',
      companyDescription: 'InnovateHub Inc.',
    },
  });

  console.log(`✅ Created ${4} positions`);

  // ============================================================================
  // 7. Candidates
  // ============================================================================
  console.log('Creating candidates...');
  const candidate1 = await prisma.candidate.create({
    data: {
      firstName: 'Alice',
      lastName: 'Williams',
      email: 'alice.williams@email.com',
      phone: '+1-555-0101',
      address: '123 Main St, San Francisco, CA',
    },
  });

  const candidate2 = await prisma.candidate.create({
    data: {
      firstName: 'Bob',
      lastName: 'Martinez',
      email: 'bob.martinez@email.com',
      phone: '+1-555-0102',
      address: '456 Oak Ave, Los Angeles, CA',
    },
  });

  const candidate3 = await prisma.candidate.create({
    data: {
      firstName: 'Carol',
      lastName: 'Anderson',
      email: 'carol.anderson@email.com',
      phone: '+1-555-0103',
      address: '789 Pine Rd, Seattle, WA',
    },
  });

  const candidate4 = await prisma.candidate.create({
    data: {
      firstName: 'David',
      lastName: 'Taylor',
      email: 'david.taylor@email.com',
      phone: '+1-555-0104',
      address: '321 Elm St, New York, NY',
    },
  });

  const candidate5 = await prisma.candidate.create({
    data: {
      firstName: 'Eva',
      lastName: 'Brown',
      email: 'eva.brown@email.com',
      phone: '+1-555-0105',
      address: '654 Maple Dr, Boston, MA',
    },
  });

  console.log(`✅ Created ${5} candidates`);

  // ============================================================================
  // 8. Applications
  // ============================================================================
  console.log('Creating applications...');
  const application1 = await prisma.application.create({
    data: {
      positionId: position1.id,
      candidateId: candidate1.id,
      applicationDate: new Date('2024-09-15'),
      status: 'interviewing',
      notes: 'Strong technical background, good cultural fit',
    },
  });

  const application2 = await prisma.application.create({
    data: {
      positionId: position1.id,
      candidateId: candidate2.id,
      applicationDate: new Date('2024-09-16'),
      status: 'reviewing',
      notes: 'Needs more experience review',
    },
  });

  const application3 = await prisma.application.create({
    data: {
      positionId: position2.id,
      candidateId: candidate1.id,
      applicationDate: new Date('2024-09-17'),
      status: 'pending',
    },
  });

  const application4 = await prisma.application.create({
    data: {
      positionId: position2.id,
      candidateId: candidate3.id,
      applicationDate: new Date('2024-09-18'),
      status: 'interviewing',
      notes: 'Excellent portfolio',
    },
  });

  const application5 = await prisma.application.create({
    data: {
      positionId: position3.id,
      candidateId: candidate4.id,
      applicationDate: new Date('2024-09-19'),
      status: 'interviewing',
      notes: 'Executive candidate with strong background',
    },
  });

  const application6 = await prisma.application.create({
    data: {
      positionId: position1.id,
      candidateId: candidate5.id,
      applicationDate: new Date('2024-09-20'),
      status: 'offered',
      notes: 'Outstanding candidate, offer extended',
    },
  });

  console.log(`✅ Created ${6} applications`);

  // ============================================================================
  // 9. Interviews
  // ============================================================================
  console.log('Creating interviews...');
  // Application 1 interviews (interviewing status)
  const interview1 = await prisma.interview.create({
    data: {
      applicationId: application1.id,
      interviewStepId: step1_1.id,
      employeeId: employee1.id,
      interviewDate: new Date('2024-09-20'),
      result: 'passed',
      score: 85,
      notes: 'Good communication skills, technical knowledge confirmed',
    },
  });

  const interview2 = await prisma.interview.create({
    data: {
      applicationId: application1.id,
      interviewStepId: step1_2.id,
      employeeId: employee2.id,
      interviewDate: new Date('2024-09-25'),
      result: 'passed',
      score: 90,
      notes: 'Excellent technical skills, solved all problems',
    },
  });

  const interview3 = await prisma.interview.create({
    data: {
      applicationId: application1.id,
      interviewStepId: step1_3.id,
      employeeId: employee1.id,
      interviewDate: new Date('2024-09-30'),
      result: 'pending',
      notes: 'Scheduled for next week',
    },
  });

  // Application 4 interviews
  const interview4 = await prisma.interview.create({
    data: {
      applicationId: application4.id,
      interviewStepId: step1_1.id,
      employeeId: employee3.id,
      interviewDate: new Date('2024-09-22'),
      result: 'passed',
      score: 88,
      notes: 'Strong candidate, moving forward',
    },
  });

  // Application 5 interviews (executive position)
  const interview5 = await prisma.interview.create({
    data: {
      applicationId: application5.id,
      interviewStepId: step2_1.id,
      employeeId: employee3.id,
      interviewDate: new Date('2024-09-21'),
      result: 'passed',
      score: 92,
      notes: 'Executive phone screen completed successfully',
    },
  });

  const interview6 = await prisma.interview.create({
    data: {
      applicationId: application5.id,
      interviewStepId: step2_2.id,
      employeeId: employee3.id,
      interviewDate: new Date('2024-09-28'),
      result: 'pending',
      notes: 'Board interview scheduled',
    },
  });

  // Application 6 interviews (offered status - completed all steps)
  const interview7 = await prisma.interview.create({
    data: {
      applicationId: application6.id,
      interviewStepId: step1_1.id,
      employeeId: employee1.id,
      interviewDate: new Date('2024-09-10'),
      result: 'passed',
      score: 90,
      notes: 'Excellent phone screen',
    },
  });

  const interview8 = await prisma.interview.create({
    data: {
      applicationId: application6.id,
      interviewStepId: step1_2.id,
      employeeId: employee2.id,
      interviewDate: new Date('2024-09-15'),
      result: 'passed',
      score: 95,
      notes: 'Outstanding technical interview',
    },
  });

  const interview9 = await prisma.interview.create({
    data: {
      applicationId: application6.id,
      interviewStepId: step1_3.id,
      employeeId: employee1.id,
      interviewDate: new Date('2024-09-18'),
      result: 'passed',
      score: 88,
      notes: 'Great cultural fit',
    },
  });

  const interview10 = await prisma.interview.create({
    data: {
      applicationId: application6.id,
      interviewStepId: step1_4.id,
      employeeId: employee1.id,
      interviewDate: new Date('2024-09-22'),
      result: 'passed',
      score: 92,
      notes: 'Final approval, offer extended',
    },
  });

  console.log(`✅ Created ${10} interviews`);

  console.log('\n✨ Seed completed successfully!');
  console.log('\nSummary:');
  console.log(`  - Companies: ${2}`);
  console.log(`  - Employees: ${4}`);
  console.log(`  - Interview Types: ${4}`);
  console.log(`  - Interview Flows: ${2}`);
  console.log(`  - Interview Steps: ${7}`);
  console.log(`  - Positions: ${4}`);
  console.log(`  - Candidates: ${5}`);
  console.log(`  - Applications: ${6}`);
  console.log(`  - Interviews: ${10}`);
}

main()
  .catch((e) => {
    console.error('❌ Error during seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

