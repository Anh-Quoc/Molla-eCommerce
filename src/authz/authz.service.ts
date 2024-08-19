// import { Injectable } from "@nestjs/common";
// import { InjectRepository } from "@nestjs/typeorm";
// import { PermissionGroup, ResourceAccessControl } from "src/permission-group/entities/PermissionGroup.entity";
// import { Repository } from "typeorm";

// @Injectable()
// export class AuthzService {
//   constructor(
//     @InjectRepository(Repository<PermissionGroup>)
//     private pgRepository: Repository<PermissionGroup>
//   ) {}

//   async findAllPermissionsOfRole(role: string): Promise<ResourceAccessControl[]> {
//     const permissions = await this.pgRepository
//     .createQueryBuilder('permission_group')
//     .where('permission_group.role = :role', { role })
//     .getOne(); // Use getMany() to retrieve multiple permissions

//     return permissions.AccessControlSet;
//   }
// }