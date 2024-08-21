import { Module } from 'node_modules/@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtModule } from 'node_modules/@nestjs/jwt';
import { jwtConstants } from './constants';
import { UsersModule } from 'src/user/users.module';
import {APP_GUARD} from "@nestjs/core";
import {AuthGuard} from "./guards/auth.guard";
import {PermissionGroupModule} from "../permission-group/PermissionGroup.module";

@Module({
  imports: [
    UsersModule,
    PermissionGroupModule,
    JwtModule.register({
      global: true,
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '24h' },
    }),
  ],
  providers: [
    AuthService,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
  controllers: [AuthController],
  exports: [AuthService],
})
export class AuthModule {}
