import { ApiProperty, ApiPropertyOptional } from 'node_modules/@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsDateString,
  Length,
  Matches,
  IsNumber,
  Equals,
  IsInt,
} from 'class-validator';

export class CreateUserInputDto {
  @ApiProperty({
    description: 'Email of the user',
    example: 'john.doe@example.com',
  })
  @IsNotEmpty()
  @Length(5, 100, { message: 'Email must be between 5 and 100 characters' })
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

  @ApiProperty({
    description: 'Permission group id for the user account',
    example: '3',
  })
  @IsNotEmpty()
  @IsInt()
  permissionGroupId: number;

  @ApiProperty({
    description: 'Full name of the user',
    example: 'John Doe',
  })
  @IsNotEmpty({ message: 'Full name is required' })
  @IsString({ message: 'Full name must be a string' })
  @Length(1, 50, { message: 'Full name must be between 1 and 50 characters' })
  @Matches(/^[a-zA-Z]+([ '-][a-zA-Z]+)*$/, {
    message:
      'Full name can only contain letters, spaces, hyphens, and apostrophes',
  })
  fullName: string;

  @ApiPropertyOptional({
    description: 'Address of the user',
    example: '123 Main St, Apt 4B, Springfield, IL 62704',
  })
  @IsOptional()
  @IsString({ message: 'Address must be a string' })
  @Length(5, 100, { message: 'Address must be between 5 and 100 characters' })
  @Matches(/^[a-zA-Z0-9\s,'-]*$/, {
    message:
      'Address can only contain letters, numbers, spaces, commas, apostrophes, and hyphens',
  })
  address?: string;

  @ApiPropertyOptional({
    description: 'Phone number of the user',
    example: '1234567890',
  })
  @IsOptional()
  @IsString()
  @Matches(/^[0-9]{10,15}$/, {
    message: 'Phone number must be a valid phone number',
  })
  phoneNumber?: string;

  @ApiPropertyOptional({
    description: 'Date of birth of the user',
    example: '1980-01-01',
  })
  @IsOptional()
  @IsDateString()
  dateOfBirth?: string;
}
