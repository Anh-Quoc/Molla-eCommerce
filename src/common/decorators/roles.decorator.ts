import { SetMetadata } from '@nestjs/common';
import { RoleEnum } from '../enums/role.enum';

export const ROLES_KEY = 'roles';
export const Roles = ( resource: string, action: string, role: string) => {
    return SetMetadata(ROLES_KEY, role);
}