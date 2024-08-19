import { ApiProperty, ApiPropertyOptional } from 'node_modules/@nestjs/swagger';
import {
  IsOptional,
  IsString,
  IsDateString,
  Matches,
  IsNotEmpty,
  Length,
  IsEmail,
} from 'class-validator';

export class UpdateUserInputDto {
  @ApiProperty({
    description: 'password',
    example: 'Abc12345',
  })
  @IsOptional()
  @IsString()
  @Length(6, 20)
  @Matches(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, {
    message:
      'Password must be at least 8 characters long and contain both letters and numbers',
  })
  password: string;

  @ApiProperty({
    description: 'Full name of the user',
    example: 'John Doe',
  })
  @IsOptional()
  @IsString()
  fullname?: string;

  @ApiPropertyOptional({
    description: 'Address of the user',
    example: 'abc',
  })
  @IsOptional()
  @IsString()
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
