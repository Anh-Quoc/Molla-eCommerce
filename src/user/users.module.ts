import { Module } from 'node_modules/@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm'
import { UsersController } from './controllers/users.controller';
import { User } from './entities/user.entity';
import { UsersService } from './services/users.service';
import { UsersAdminController } from './controllers/users.admin.controller';
import { UsersAdminService } from './services/users.admin.service';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService, UsersAdminService],
  controllers: [UsersController, UsersAdminController],
  exports: [UsersService],
})
export class UsersModule {}
