import { NestFactory } from 'node_modules/@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from 'node_modules/@nestjs/swagger';
import { ValidationPipe } from 'node_modules/@nestjs/common';

async function bootstrap() {
  // Create the NestJS application
  const app = await NestFactory.create(AppModule);

  // Apply global validation pipe to validate and transform request data
  app.useGlobalPipes(new ValidationPipe());

  // Configure Swagger API documentation
  const config = new DocumentBuilder()
    .setTitle('Shop Example API') // Set the title of the API
    .setDescription('API description for the Shop Example application') // Set the description of the API
    .setVersion('1.0') // Set the version of the API
    .build();

  // Create the Swagger document
  const document = SwaggerModule.createDocument(app, config);

  // Set up Swagger UI at the `/api` endpoint
  SwaggerModule.setup('api', app, document);

  // Start the application and listen on port 3000
  await app.listen(3000);
}

bootstrap();
