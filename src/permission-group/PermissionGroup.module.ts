import { Module } from 'node_modules/@nestjs/common';
import { PermissionGroupService } from './services/PermissionGroup.admin.service';
import { TypeOrmModule } from 'node_modules/@nestjs/typeorm';
import { PermissionGroup } from './entities/PermissionGroup.entity';
import { PermissionGroupAdminController } from './controllers/PermissionGroup.admin.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PermissionGroup])],
  controllers: [PermissionGroupAdminController],
  providers: [PermissionGroupService],
  exports: [PermissionGroupService]
})
export class GroupPermissionsModule {}
