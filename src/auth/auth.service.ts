import {
    BadRequestException,
    Injectable,
    Logger,
    NotFoundException,
    UnauthorizedException,
  } from 'node_modules/@nestjs/common';
  import { JwtService } from 'node_modules/@nestjs/jwt';
  import { UsersService } from 'src/user/services/users.service';
  
  @Injectable()
  export class AuthService {
    // private accountService: AccountsService;
    private readonly logger = new Logger(AuthService.name);
    constructor(
      private jwtService: JwtService,
      private usersService: UsersService,
    ) {}
  
    // async findAllPermissionsOfUser(user: User): Promise<Permission[]> {
    //   return await this.userRepository.findAllPermissions(user);
    // }

    async signIn(email: string, password: string): Promise<any> {
      const user = await this.usersService.findByEmail(email);
      this.logger.log(`user: ${JSON.stringify(user)}`);
      if (!user) {
        throw new NotFoundException();
      }
  
      let md5 = require('md5');
  
      if (user.password !== md5(password)) {
        throw new BadRequestException('user or password incorrect');
      }
  
      // Generate a JWT and return
      const payload = {
        sub: user.id,
        
      }; // Adjust as needed to get role names or IDs
      return {
        access_token: await this.jwtService.signAsync(payload),
      };
      // role: user.role,
    }
  }
  