import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import {
    Column,
    ManyToOne,
    JoinColumn,
} from 'node_modules/typeorm';
import { PermissionGroup } from 'src/permission-group/entities/PermissionGroup.entity';


export class UserAdminResponseDto {
    @ApiProperty()
    @Expose()
    id: number;

    @ApiProperty()
    @Expose()
    email: string;

    @ApiProperty()
    @Column()
    permissionGroupId: number;
    
    @ManyToOne(() => PermissionGroup, (permissionGroup) => permissionGroup.users)
    @JoinColumn({ name: 'permissionGroupId' })
    permissionGroup: PermissionGroup;

    @ApiProperty()
    @Expose()
    fullname: string;

    @ApiProperty()
    @Expose()
    address: string;

    @ApiProperty()
    @Expose()
    phoneNumber: string;

    @ApiProperty({
        type: Date,
    })
    @Expose()
    @Type(() => Date)
    dateOfBirth: Date;

    @ApiProperty()
    @Expose()
    roleId: number;

    @ApiProperty()
    @Expose()
    lastLogin: Date;

    @ApiProperty()
    @Expose()
    created_at: Date;

    @ApiProperty()
    @Expose()
    updated_at: Date;

    @ApiProperty()
    @Expose()
    isActive: boolean;
}
