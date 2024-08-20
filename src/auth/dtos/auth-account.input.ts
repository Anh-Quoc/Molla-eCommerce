import { IsEmail, IsNotEmpty, IsString, Length, Matches } from 'class-validator';
import { ApiProperty } from 'node_modules/@nestjs/swagger';

export class AuthAccountInputDto {
  @ApiProperty({
    description: 'Email of the user',
    example: 'alice.jones@example.com',
  })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'password',
    example: 'Abc12345',
  })
  @IsNotEmpty()
  @IsString()
  @Length(6, 20)
  @Matches(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, {
    message:
      'Password must be at least 8 characters long and contain both letters and numbers',
  })
  password: string;
}
