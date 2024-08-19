// import { Ability } from "@casl/ability";
// import { Injectable } from "@nestjs/common";
// import { AuthzService } from "./authz.service";
// import { User } from "src/user/entities/user.entity";

// import { ResourceAccessControl } from "src/permission-group/entities/PermissionGroup.entity";
// export enum PermissionAction {
//   CREATE = "create",
//   READ = "read",
//   UPDATE = "update",
//   DELETE = "delete",
// }

// export type PermissionObjectType = any;
// export type AppAbility = Ability<[PermissionAction, PermissionObjectType]>;
// interface CaslPermission {
//   action: PermissionAction;
//   // In our database, Invoice, Project... are called "object"
//   // but in CASL they are called "subject"
//   subject: string;
// }
// @Injectable()
// export class CaslAbilityFactory {
//   constructor(private authoService: AuthzService) { 

//   }

//   async createForRole(role: string): Promise<AppAbility> {
//     const dbPermissions: ResourceAccessControl[] = await this.authoService.findAllPermissionsOfRole(role);

//     const caslPermissions: CaslPermission[] = dbPermissions.map(p => ({
//       action: p.action,
//       subject: p.resource,
//     }));
//     return new Ability<[PermissionAction, PermissionObjectType]>(caslPermissions);
//   }
// }