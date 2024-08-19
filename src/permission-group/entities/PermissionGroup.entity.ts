import {
  Column,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'node_modules/typeorm';
import { User } from 'src/user/entities/user.entity';
import { IsBoolean, IsString, ValidateNested } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
// import { PermissionAction } from 'src/authz/casl-ability.factory';

export class PermissionAction{
  @ApiProperty({

  })
  @IsBoolean()
  create: boolean;
  @ApiProperty({
      
  })
  @IsBoolean()
  read: boolean;
  @ApiProperty({
      
  })
  @IsBoolean()
  update: boolean;
  @ApiProperty({
      
  })
  @IsBoolean()
  delete: boolean;
}

export class ResourceAccessControl {
  @ApiProperty({
      
  })
  @IsString()
  resource: string;
  @ApiProperty({
      type: PermissionAction
  })
  action : PermissionAction
}

@Entity({ name: 'permission_group' })
export class PermissionGroup {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({unique: true})
  role: string;

  @OneToMany(() => User, (user) => user.permissionGroup, {
    cascade: true,
    onDelete: 'CASCADE'
  })
  users: User[];

  @Column('jsonb')
  AccessControlSet: ResourceAccessControl[];
}
