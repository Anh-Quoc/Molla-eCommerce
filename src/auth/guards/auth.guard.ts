import {CanActivate, ExecutionContext, Injectable, Logger, UnauthorizedException} from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { jwtConstants } from "../constants";
import { Request } from "express";
import {IS_PUBLIC_KEY} from "../decorator/public.decorator";
import {Reflector} from "@nestjs/core";

  
  @Injectable()
  export class AuthGuard implements CanActivate {
    private readonly logger = new Logger(AuthGuard.name);

    constructor(private jwtService: JwtService, private reflector: Reflector) {}

    async canActivate(context: ExecutionContext): Promise<boolean> {

      const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
        context.getHandler(),
        context.getClass(),
      ]);
      if (isPublic) {
        // 💡 See this condition
        return true;
      }
      const request = context.switchToHttp().getRequest();
      const token = this.extractTokenFromHeader(request);

      if (!token) {
        throw new UnauthorizedException();
      }

      try {

        const payload = await this.jwtService.verifyAsync(token, {
          secret: jwtConstants.secret,
        });

        this.logger.log('Payload: ' + payload.toString())

        request['user_id'] = payload.sub;
        request['permission'] = payload.permission;
      } catch {
        this.logger.log('Unauthorized')
        throw new UnauthorizedException();
      }
      return true;
    }

    private extractTokenFromHeader(request: Request): string | undefined {
      const [type, token] = request.headers.authorization?.split(' ') ?? [];
      return type === 'Bearer' ? token : undefined;
    }
  }
  
  