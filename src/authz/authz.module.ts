// import { Global, Module } from "@nestjs/common";
// import { AuthzService } from "./authz.service";
// import { Repository } from "typeorm";
// import { User } from "src/user/entities/user.entity";
// import { TypeOrmModule } from "@nestjs/typeorm";
// import { CaslAbilityFactory } from "./casl-ability.factory";
// import { PermissionsGuard } from "./permissions.guard";

// @Global()
// @Module({
//   imports: [
//     TypeOrmModule.forFeature([Repository<User>]),
//   ],
//   providers: [CaslAbilityFactory, PermissionsGuard, AuthzService],
//   exports: [CaslAbilityFactory, PermissionsGuard],
// })
// export class AuthzModule {}