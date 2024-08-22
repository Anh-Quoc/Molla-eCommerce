import {
    Column,
    Entity,
    OneToMany,
    PrimaryGeneratedColumn,
} from 'node_modules/typeorm';
import {User} from 'src/users/entities/User.entity';
import {IsBoolean, IsString} from 'class-validator';
import {ApiProperty} from '@nestjs/swagger';

export class PermissionAction {
    @ApiProperty({})
    @IsBoolean()
    create: boolean;
    @ApiProperty({})
    @IsBoolean()
    read: boolean;
    @ApiProperty({})
    @IsBoolean()
    update: boolean;
    @ApiProperty({})
    @IsBoolean()
    delete: boolean;
}

export class ResourceAccessControl {
    @ApiProperty({})
    @IsString()
    resource: string;
    @ApiProperty({
        type: PermissionAction
    })
    action: PermissionAction
}

@Entity({name: 'permission_group'})
export class PermissionGroup {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({unique: true})
    name: string;

    @OneToMany(() => User, (user) => user.permissionGroup, {
        cascade: true,
        onDelete: 'CASCADE'
    })
    users: User[];

    @Column({name: 'permissions', type: "jsonb"})
    permissions: ResourceAccessControl[];

    @Column({name: 'active'})
    active: boolean;


}


