import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function main() {
  // Crear instituciones
  const institutions = await prisma.institution.createMany({
    data: [
      { name: 'Universidad Nacional' },
      { name: 'Tecnológico de Monterrey' },
      { name: 'IPN' },
      { name: 'UAM' },
      { name: 'Universidad Autónoma de Yucatán' },
    ],
  })

  // Crear títulos laborales
  const jobTitles = await prisma.jobTitle.createMany({
    data: [
      { name: 'Desarrollador Backend' },
      { name: 'Ingeniero de Datos' },
      { name: 'Analista de QA' },
      { name: 'Scrum Master' },
      { name: 'Fullstack Developer' },
    ],
  })

  // Crear carreras
  const careers = await prisma.career.createMany({
    data: [
      { name: 'Ingeniería en Sistemas' },
      { name: 'Ciencias de la Computación' },
      { name: 'Tecnologías de la Información' },
      { name: 'Ingeniería en Software' },
      { name: 'Matemáticas Aplicadas' },
    ],
  })

  const institutionsAll = await prisma.institution.findMany()
  const jobTitlesAll = await prisma.jobTitle.findMany()
  const careersAll = await prisma.career.findMany()

  for (let i = 1; i <= 10; i++) {
    const candidate = await prisma.candidate.create({
      data: {
        firstName: `Nombre${i}`,
        lastName: `Apellido${i}`,
        email: `candidato${i}@mail.com`,
        phone: `55510020${i}`,
        address: `Calle Ficticia #${i}`,
        career: { connect: { id: careersAll[i % careersAll.length].id } },
        educations: {
          create: [
            {
              institution: { connect: { id: institutionsAll[i % institutionsAll.length].id } },
              jobTitle: { connect: { id: jobTitlesAll[i % jobTitlesAll.length].id } },
              startDate: new Date(`201${i % 5}-08-01`),
              endDate: new Date(`201${(i % 5) + 1}-06-30`),
            },
          ],
        },
        workExperiences: {
          create: [
            {
              company: `Empresa ${i}`,
              jobTitle: { connect: { id: jobTitlesAll[i % jobTitlesAll.length].id } },
              startDate: new Date(`2020-01-01`),
              endDate: new Date(`2022-12-31`),
              description: `Trabajo desempeñado en Empresa ${i}`,
            },
          ],
        },
        resumes: {
          create: [
            {
              fileName: `cv_candidato${i}.pdf`,
              fileUrl: `https://example.com/cv_candidato${i}.pdf`,
              uploadedAt: new Date(),
            },
          ],
        },
      },
    })
  }
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })