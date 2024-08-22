import {
    BadRequestException,
    Injectable,
    Logger,
    NotFoundException,
    UnauthorizedException,
  } from 'node_modules/@nestjs/common';
  import { JwtService } from 'node_modules/@nestjs/jwt';
  import { UsersService } from 'src/users/services/users.service';
import * as bcrypt from "bcrypt";
  
  @Injectable()
  export class AuthService {
    // private accountService: AccountsService;
    private readonly logger = new Logger(AuthService.name);
    constructor(
      private jwtService: JwtService,
      private usersService: UsersService,

    ) {}

    async login(email: string, password: string): Promise<string> {
      const user = await this.usersService.findByEmail(email);
      // this.logger.log(`user: ${JSON.stringify(user)}`);
      if (!user) {
        throw new NotFoundException();
      }
      // this.logger.log(`user: ${JSON.stringify(user)}`);
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        // this.logger.error('Password does not match');
        throw new UnauthorizedException();
      }

      await this.usersService.updateLoginDate(user.id);

      // Generate a JWT and return
      const payload = {
        sub: user.id,
        permission: user.permissionGroupId,
      };
      return await this.jwtService.signAsync(payload);
    }
  }
  