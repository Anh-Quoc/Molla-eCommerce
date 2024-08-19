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

  @Column({ nullable: false })
  fullname: string;

  @Column({ unique: true, nullable: false })
  email: string;

  @Column({ nullable: false })
  password: string;
  
  @Column()
  permissionGroupId: number;

  @ManyToOne(() => PermissionGroup, (permissionGroup) => permissionGroup.users)
  @JoinColumn({name: 'permissionGroupId'})
  permissionGroup: PermissionGroup;

  @Column({ nullable: true })
  address: string;

  @Column({ nullable: true })
  phoneNumber: string;

  @Column({ nullable: true })
  dateOfBirth: Date;

  @Column({ nullable: true })
  lastLogin: Date;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ nullable: false, default: true })
  isActive: boolean;
}
