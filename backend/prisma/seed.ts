import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  // Seed Interview Types
  console.log('📋 Seeding interview types...');
  const interviewTypes = await Promise.all([
    prisma.interviewType.upsert({
      where: { name: 'Technical' },
      update: {},
      create: {
        name: 'Technical',
        description: 'Technical assessment and coding challenges',
      },
    }),
    prisma.interviewType.upsert({
      where: { name: 'Behavioral' },
      update: {},
      create: {
        name: 'Behavioral',
        description: 'Behavioral and cultural fit assessment',
      },
    }),
    prisma.interviewType.upsert({
      where: { name: 'System Design' },
      update: {},
      create: {
        name: 'System Design',
        description: 'System design and architecture discussion',
      },
    }),
    prisma.interviewType.upsert({
      where: { name: 'Final' },
      update: {},
      create: {
        name: 'Final',
        description: 'Final interview with leadership team',
      },
    }),
  ]);

  // Seed Interview Flows
  console.log('🔄 Seeding interview flows...');
  const standardFlow = await prisma.interviewFlow.upsert({
    where: { id: 1 },
    update: {},
    create: {
      description: 'Standard Software Engineer Interview Process',
    },
  });

  const seniorFlow = await prisma.interviewFlow.upsert({
    where: { id: 2 },
    update: {},
    create: {
      description: 'Senior Software Engineer Interview Process',
    },
  });

  // Seed Interview Steps
  console.log('👥 Seeding interview steps...');
  await Promise.all([
    // Standard flow steps
    prisma.interviewStep.upsert({
      where: { id: 1 },
      update: {},
      create: {
        interviewFlowId: standardFlow.id,
        interviewTypeId: interviewTypes[1].id, // Behavioral
        name: 'Initial HR Screen',
        orderIndex: 1,
      },
    }),
    prisma.interviewStep.upsert({
      where: { id: 2 },
      update: {},
      create: {
        interviewFlowId: standardFlow.id,
        interviewTypeId: interviewTypes[0].id, // Technical
        name: 'Technical Assessment',
        orderIndex: 2,
      },
    }),
    prisma.interviewStep.upsert({
      where: { id: 3 },
      update: {},
      create: {
        interviewFlowId: standardFlow.id,
        interviewTypeId: interviewTypes[3].id, // Final
        name: 'Final Interview',
        orderIndex: 3,
      },
    }),

    // Senior flow steps
    prisma.interviewStep.upsert({
      where: { id: 4 },
      update: {},
      create: {
        interviewFlowId: seniorFlow.id,
        interviewTypeId: interviewTypes[1].id, // Behavioral
        name: 'Initial HR Screen',
        orderIndex: 1,
      },
    }),
    prisma.interviewStep.upsert({
      where: { id: 5 },
      update: {},
      create: {
        interviewFlowId: seniorFlow.id,
        interviewTypeId: interviewTypes[0].id, // Technical
        name: 'Technical Deep Dive',
        orderIndex: 2,
      },
    }),
    prisma.interviewStep.upsert({
      where: { id: 6 },
      update: {},
      create: {
        interviewFlowId: seniorFlow.id,
        interviewTypeId: interviewTypes[2].id, // System Design
        name: 'System Design Round',
        orderIndex: 3,
      },
    }),
    prisma.interviewStep.upsert({
      where: { id: 7 },
      update: {},
      create: {
        interviewFlowId: seniorFlow.id,
        interviewTypeId: interviewTypes[3].id, // Final
        name: 'Leadership Interview',
        orderIndex: 4,
      },
    }),
  ]);

  // Seed Companies
  console.log('🏢 Seeding companies...');
  const companies = await Promise.all([
    prisma.company.upsert({
      where: { name: 'LTI Consulting' },
      update: {},
      create: {
        name: 'LTI Consulting',
      },
    }),
    prisma.company.upsert({
      where: { name: 'TechCorp Solutions' },
      update: {},
      create: {
        name: 'TechCorp Solutions',
      },
    }),
    prisma.company.upsert({
      where: { name: 'Innovation Labs' },
      update: {},
      create: {
        name: 'Innovation Labs',
      },
    }),
  ]);

  // Seed Employees
  console.log('👨‍💼 Seeding employees...');
  await Promise.all([
    prisma.employee.upsert({
      where: { id: 1 },
      update: {},
      create: {
        companyId: companies[0].id,
        name: 'Sarah Johnson',
        email: 'sarah.johnson@lti.com',
        role: 'HR Manager',
        isActive: true,
      },
    }),
    prisma.employee.upsert({
      where: { id: 2 },
      update: {},
      create: {
        companyId: companies[0].id,
        name: 'Michael Chen',
        email: 'michael.chen@lti.com',
        role: 'Senior Software Engineer',
        isActive: true,
      },
    }),
    prisma.employee.upsert({
      where: { id: 3 },
      update: {},
      create: {
        companyId: companies[0].id,
        name: 'Emily Rodriguez',
        email: 'emily.rodriguez@lti.com',
        role: 'Technical Lead',
        isActive: true,
      },
    }),
    prisma.employee.upsert({
      where: { id: 4 },
      update: {},
      create: {
        companyId: companies[1].id,
        name: 'David Kim',
        email: 'david.kim@techcorp.com',
        role: 'Engineering Manager',
        isActive: true,
      },
    }),
  ]);

  // Seed Positions
  console.log('💼 Seeding positions...');
  await Promise.all([
    prisma.position.upsert({
      where: { id: 1 },
      update: {},
      create: {
        companyId: companies[0].id,
        interviewFlowId: standardFlow.id,
        title: 'Frontend Developer',
        description: 'React and TypeScript developer position',
        status: 'ACTIVE',
        isVisible: true,
        location: 'Barcelona, Spain',
        jobDescription: 'We are looking for a skilled Frontend Developer to join our team...',
        requirements: '3+ years experience with React, TypeScript, and modern frontend tools',
        responsibilities: 'Develop user interfaces, collaborate with design team, optimize performance',
        salaryMin: 45000,
        salaryMax: 65000,
        employmentType: 'FULL_TIME',
        benefits: 'Health insurance, flexible hours, remote work options',
        applicationDeadline: new Date('2024-12-31'),
        contactInfo: 'careers@lti.com',
      },
    }),
    prisma.position.upsert({
      where: { id: 2 },
      update: {},
      create: {
        companyId: companies[0].id,
        interviewFlowId: seniorFlow.id,
        title: 'Senior Backend Developer',
        description: 'Node.js and PostgreSQL backend developer position',
        status: 'ACTIVE',
        isVisible: true,
        location: 'Madrid, Spain',
        jobDescription: 'We are seeking a Senior Backend Developer to architect and build scalable systems...',
        requirements: '5+ years experience with Node.js, PostgreSQL, microservices architecture',
        responsibilities: 'Design APIs, optimize database performance, mentor junior developers',
        salaryMin: 60000,
        salaryMax: 85000,
        employmentType: 'FULL_TIME',
        benefits: 'Health insurance, stock options, professional development budget',
        applicationDeadline: new Date('2024-12-31'),
        contactInfo: 'careers@lti.com',
      },
    }),
    prisma.position.upsert({
      where: { id: 3 },
      update: {},
      create: {
        companyId: companies[1].id,
        interviewFlowId: standardFlow.id,
        title: 'Full Stack Developer',
        description: 'Full stack developer with React and Node.js experience',
        status: 'ACTIVE',
        isVisible: true,
        location: 'Valencia, Spain',
        jobDescription: 'Join our innovative team as a Full Stack Developer...',
        requirements: '3+ years full stack experience, React, Node.js, MongoDB',
        responsibilities: 'Build end-to-end features, collaborate with product team, maintain code quality',
        salaryMin: 50000,
        salaryMax: 70000,
        employmentType: 'FULL_TIME',
        benefits: 'Health insurance, flexible schedule, gym membership',
        applicationDeadline: new Date('2024-12-31'),
        contactInfo: 'jobs@techcorp.com',
      },
    }),
  ]);

  console.log('✅ Database seeding completed successfully!');
  console.log('📊 Summary:');
  console.log(`- ${interviewTypes.length} interview types created`);
  console.log('- 2 interview flows created');
  console.log('- 7 interview steps created');
  console.log(`- ${companies.length} companies created`);
  console.log('- 4 employees created');
  console.log('- 3 positions created');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 