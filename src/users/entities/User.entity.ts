import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'node_modules/typeorm';
import { PermissionGroup } from 'src/permission-group/entities/PermissionGroup.entity';

@Entity({ name: 'users' })
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'full_name', nullable: false })
  fullName: string;

  @Column({ unique: true, nullable: false })
  email: string;

  @Column({ nullable: false })
  password: string;
  
  @Column({name: 'permission_group_id', nullable: false})
  permissionGroupId: number;

  @ManyToOne(() => PermissionGroup, (permissionGroup) => permissionGroup.users)
  @JoinColumn({name: 'permission_group_id'})
  permissionGroup: PermissionGroup;

  @Column({ nullable: true })
  address: string;

  @Column({ name: 'phone', nullable: true })
  phoneNumber: string;

  @Column({ name: 'dob', nullable: true })
  dateOfBirth: Date;

  @Column({ name: 'last_login',  nullable: true })
  lastLogin: Date;

  @CreateDateColumn({name: 'created_at'})
  createdAt: Date;

  @UpdateDateColumn({name: 'updated_at'})
  updatedAt: Date;

  @Column({ name: 'active', nullable: false, default: true })
  isActive: boolean;
}
