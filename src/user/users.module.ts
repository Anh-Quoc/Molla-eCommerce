import { Module } from 'node_modules/@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm'
import { UsersController } from './controllers/users.controller';
import { User } from './entities/User.entity';
import { UsersService } from './services/users.service';
import { UsersAdminController } from './controllers/users.admin.controller';
import { UsersAdminService } from './services/users.admin.service';
import {PermissionGroupService} from "../permission-group/services/PermissionGroup.service";
import {PermissionGroup} from "../permission-group/entities/PermissionGroup.entity";

@Module({
  imports: [TypeOrmModule.forFeature([User]), TypeOrmModule.forFeature([PermissionGroup])],
  providers: [UsersService, UsersAdminService],
  controllers: [UsersController, UsersAdminController],
  exports: [UsersService],
})
export class UsersModule {}
