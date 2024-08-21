import { Module } from 'node_modules/@nestjs/common';
import { PermissionGroupAdminService } from './services/PermissionGroup.admin.service';
import { TypeOrmModule } from 'node_modules/@nestjs/typeorm';
import { PermissionGroup } from './entities/PermissionGroup.entity';
import { PermissionGroupAdminController } from './controllers/PermissionGroup.admin.controller';
import {PermissionGroupService} from "./services/PermissionGroup.service";

@Module({
  imports: [TypeOrmModule.forFeature([PermissionGroup])],
  controllers: [PermissionGroupAdminController],
  providers: [PermissionGroupAdminService, PermissionGroupService],
  exports: [PermissionGroupService]
})
export class PermissionGroupModule {}
