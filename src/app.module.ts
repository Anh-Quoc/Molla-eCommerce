import { Module } from 'node_modules/@nestjs/common';
import { TypeOrmModule } from 'node_modules/@nestjs/typeorm';
import { ConfigModule, ConfigService } from 'node_modules/@nestjs/config';

import { AuthModule } from './auth/auth.module';
import { UsersModule } from './user/users.module';
import { GroupPermissionsModule } from './permission-group/PermissionGroup.module';
import { PermissionGroup } from './permission-group/entities/PermissionGroup.entity';
import { User } from './user/entities/User.entity';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [
    ConfigModule.forRoot(), // Load environment variables from .env file
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get<string>('DB_USERNAME'),
        password: configService.get<string>('DB_PASSWORD'),
        database: configService.get<string>('DB_DATABASE'),
        entities: [User, PermissionGroup],
        synchronize: false,
      }),
    }),

    AuthModule,
    UsersModule,
    GroupPermissionsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
