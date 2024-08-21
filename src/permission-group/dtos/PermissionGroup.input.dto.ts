import { ApiProperty } from 'node_modules/@nestjs/swagger';
import {
  IsArray,
  IsNotEmpty,
  IsObject,
  IsString,
  Length,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ResourceAccessControl } from '../entities/PermissionGroup.entity';

export class PermissionGroupInputDto {
  @ApiProperty({
    description: 'The name of the group. It must be unique and descriptive.',
    example: 'Customer',
    maxLength: 50,
  })
  @IsNotEmpty({ message: 'Name is required' })
  @IsString({ message: 'Name must be a string' })
  @Length(1, 50, { message: 'Name must be between 1 and 50 characters' })
  name: string;

  @ApiProperty({
    description: 'List of permissions associated with',
    example: [
      {
        "resource": "post",
        "action": {
          "create": false,
          "read": true,
          "update": false,
          "delete": false
        }
      },
      {
        "resource": "comment",
        "action": {
          "create": true,
          "read": true,
          "update": true,
          "delete": true
        }
      }
    ],
    type: ResourceAccessControl,
  })
  @IsNotEmpty()
  @IsArray()
  @Type(() => ResourceAccessControl)
  @ValidateNested({each : true}) // Use Object if no specific structure for nested items
  permissions: ResourceAccessControl[];
}
