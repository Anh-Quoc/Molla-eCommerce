// src/common/guards/permissions.guard.ts
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from '../decorator/permissions.decorator';
import {UsersAdminService} from "../../user/services/users.admin.service";
import {PermissionGroupService} from "../../permission-group/services/PermissionGroup.service";
import {PermissionGroup, ResourceAccessControl} from "../../permission-group/entities/PermissionGroup.entity";

@Injectable()
export class PermissionsGuard implements CanActivate {
    constructor(
        private reflector: Reflector,
        private permissionGroupService: PermissionGroupService
    ) {}

    canActivate(context: ExecutionContext): boolean {
        const requiredPermissions = this.reflector.getAllAndOverride<ResourceAccessControl[]>(PERMISSIONS_KEY, [
            context.getHandler(),
            context.getClass(),
        ]);
        if (!requiredPermissions) {
            return true; // If no permissions are required, grant access.
        }

        const request = context.switchToHttp().getRequest();
        // const user = request.user;
        //
        const userId = request.user_id;
        const permission_id = request.permission;

        const permissionGroup = this.permissionGroupService.findById(permission_id);

        if (!userId) {
            throw new ForbiddenException('User not authenticated');
        }

        // Compare user's permissions with the permissions in the fetched permission group
        const hasPermission = permissionGroup.permission.some((perm) => requiredPermissions.includes(perm));

        if (!hasPermission) {
            throw new ForbiddenException('User does not have required permissions');
        }

        return true;
    }
}
