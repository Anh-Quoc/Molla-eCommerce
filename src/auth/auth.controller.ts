import {Body, Controller, HttpCode, HttpStatus, Post} from 'node_modules/@nestjs/common';
import {AuthService} from './auth.service';
import {AuthAccountInputDto} from './dtos/auth-account.input';
import {ApiOperation, ApiResponse} from 'node_modules/@nestjs/swagger';
import {Logger} from "@nestjs/common";
import {Public} from "./decorator/public.decorator";
import {ApiTags} from "@nestjs/swagger";

@Controller('/auth')
export class AuthController {
  private readonly logger = new Logger(AuthController.name);
  constructor(
      private authService: AuthService,) {}

  @ApiOperation({
    summary: 'Authenticate a user',
    description: 'Authenticate a user and issue a token for subsequent requests.'
  })
  @ApiTags('Common', 'Customer', 'Admin')
  @ApiResponse({
    status: 200,
    description: 'Authentication successful',
    content: {
      'application/json': {
        schema: {
          type: 'object',
          properties: {
            token: {
              type: 'string',
              example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
              description: 'The JWT token issued for authenticated requests.'
            },
            message: {
              type: 'string',
              example: "Authentication successful"
            }
          }
        }
      }
    }
  })
  @ApiResponse({
    status: 400,
    description:
      'Bad request. The provided email or password is invalid or missing.',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized. The email or password is incorrect.',
  })
  @ApiResponse({
    status: 500,
    description:
      'Internal server error. The sign-in process could not be completed due to a server issue.',
  })
  @HttpCode(HttpStatus.OK)
  @Public()
  @Post('/login')
  async login(@Body() signInDto: AuthAccountInputDto) {
    let tokenString: string = await this.authService.login(signInDto.email, signInDto.password);
    return {
      token: tokenString,
      message: 'Authentication successful',
    };
  }


}
