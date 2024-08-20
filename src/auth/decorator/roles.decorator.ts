// src/common/decorators/roles.decorator.ts
import {createParamDecorator, ExecutionContext, SetMetadata} from '@nestjs/common';

// export const Roles = (...roles: string[]) => SetMetadata('roles', roles);
export const Roles = createParamDecorator((resource: string, permission: string) => {
    SetMetadata('resource', resource);
    SetMetadata('permission', permission);
})

// export const GetUser = createParamDecorator(
//     (data: unknown, ctx: ExecutionContext) => {
//         const request = ctx.switchToHttp().getRequest();
//         return request.user?.email;
//     },
// );