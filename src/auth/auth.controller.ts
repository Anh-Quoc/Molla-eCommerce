import { Body, Controller, HttpCode, HttpStatus, Post } from 'node_modules/@nestjs/common';
import { AuthService } from './auth.service';
import { AuthAccountInputDto } from './dtos/auth-account.input';
import { ApiOperation, ApiResponse } from 'node_modules/@nestjs/swagger';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @ApiOperation({
    summary: 'Sign in an existing user',
    description:
      'This endpoint allows an existing user to sign in with their email and password. Upon successful authentication, a token or session information is returned.',
  })
  @ApiResponse({
    status: 200,
    description:
      'Successfully signed in. Returns authentication token or session information.',
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
  @Post('login')
  // Sign in API
  signIn(@Body() signInDto: AuthAccountInputDto) {
    return this.authService.signIn(signInDto.email, signInDto.password);
  }
}
