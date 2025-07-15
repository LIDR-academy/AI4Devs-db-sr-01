# Prompts

Clause Sonnet 4 on my VS's settings for copilot

# 1 - Read the diagram

Role: you're a specialist in database and analysis requirements

Task: we need to understand the proposed changes

Context: we're expanding the codebase, we have a new diagram showing how the database will look like, and we need to understand the changes that are being proposed.

The changes are defined in the following diagram:
[diagram]

# 2 - Explaining some details

In broad strokes, without entering much code, what would be the changes necessaries?

# 3 - Code changes

Let's start by changing the schema.prisma so to create a new migration .sql

We know the work is done if "npx prisma migrate dev" creates a successfull migration