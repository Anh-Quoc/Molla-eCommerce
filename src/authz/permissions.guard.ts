// import { CanActivate, ExecutionContext, Injectable } from "@nestjs/common";
// import { Reflector } from "@nestjs/core";
// import { PERMISSION_CHECKER_KEY, RequiredPermission } from "./permissions.decorator";
// import { AppAbility, CaslAbilityFactory } from "./casl-ability.factory";
// import { Request } from "express";

// @Injectable()
// export class PermissionsGuard implements CanActivate {
//     constructor(private reflector: Reflector, private abilityFactory: CaslAbilityFactory) { }
//     async canActivate(context: ExecutionContext): Promise<boolean> {


//         const requiredPermissions =
//             this.reflector.get<RequiredPermission[]>(PERMISSION_CHECKER_KEY, context.getHandler()) || [];

//         const request = context.switchToHttp().getRequest();
//         const token = this.extractTokenFromHeader(request);

//         const ability = await this.abilityFactory.createForRole('Staff');
        
//         return requiredPermissions.every(permission => this.isAllowed(ability, permission));
//     }
//     private isAllowed(ability: AppAbility, permission: RequiredPermission): boolean {
//         return ability.can(...permission);
//     }

//     private extractTokenFromHeader(request: Request): string | undefined {
//         const [type, token] = request.headers.authorization?.split(' ') ?? [];
//         return type === 'Bearer' ? token : undefined;
//     }
// }