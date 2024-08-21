import {Injectable, NotFoundException} from 'node_modules/@nestjs/common';
import {InjectRepository} from 'node_modules/@nestjs/typeorm';
import {Repository} from 'node_modules/typeorm';
import {User} from '../entities/User.entity';
import {UpdateUserInputDto} from '../dtos/update-user.input.dto';
import * as bcrypt from "bcrypt";
import {CustomerRegisterDto} from '../dtos/customer-register.dto';
import {PermissionGroup} from "../../permission-group/entities/PermissionGroup.entity";
import {PermissionGroupAdminService} from "../../permission-group/services/PermissionGroup.admin.service";
import {PermissionGroupService} from "../../permission-group/services/PermissionGroup.service";
import {plainToClass} from "class-transformer";

@Injectable()
export class UsersService {

    constructor(
        @InjectRepository(User)
        private userRepository: Repository<User>,
        @InjectRepository(PermissionGroup)
        private permissionGroupRepository: Repository<PermissionGroup>,
    ) {
    }

    async findAll(): Promise<User[]> {
        const profile = await this.userRepository
            .createQueryBuilder('users')
            .getMany();

        // .where('profile.roleId = 3', { roleId: 3 })

        return profile;
    }

    async findById(userId: number): Promise<User> {
        const profile = await this.userRepository
            .createQueryBuilder('users')
            .where('users.id = :id', {id: userId})
            .getOne();

        // .where('profile.roleId = 3', { roleId: 3 })
        // .andWhere('profile.id = :id', { id: userId })
        if (!profile) {
            throw new NotFoundException(`User profile with ID ${userId} not found`);
        }

        return profile;
    }

    async create(newUser: CustomerRegisterDto): Promise<User> {
        const salt = await bcrypt.genSalt();
        let hashPassword = await bcrypt.hash(newUser.password, salt);
        newUser.password = hashPassword;

        const permissionGroup = await this.permissionGroupRepository
            .createQueryBuilder('permission_group')
            .where('permission_group.name = :name', {name: 'Customer'})
            .getOne();

        if (!permissionGroup) {
            throw new NotFoundException(`Permission group with name Customer not found`);
        }

        let user = this.convertToUserEntity(newUser);
        user.permissionGroupId = permissionGroup.id;

        return this.userRepository.save(user);
    }

    convertToUserEntity(newUser: CustomerRegisterDto): User {
        const user = new User();
        user.email = newUser.email;
        user.password = newUser.password;
        user.fullName = newUser.fullName;
        user.address = newUser.address;
        user.phoneNumber = newUser.phoneNumber;
        user.dateOfBirth = newUser.dateOfBirth;
        return user;
    }

    async update(
        userId: number,
        updateUserInputDto: UpdateUserInputDto,
    ): Promise<User> {
        const existingProfile = await this.userRepository.findOne({
            where: {id: userId},
        });

        if (!existingProfile) {
            throw new NotFoundException(`User profile with ID ${userId} not found`);
        }

        const updatedProfile = this.userRepository.merge(
            existingProfile,
            updateUserInputDto,
        );

        return this.userRepository.save(updatedProfile);
    }

    async updateLoginDate(
        userId: number
    ): Promise<User> {
        const existingProfile = await this.userRepository.findOne({
            where: {id: userId},
        });

        if (!existingProfile) {
            throw new NotFoundException(`User profile with ID ${userId} not found`);
        }

        existingProfile.lastLogin = new Date();

        return this.userRepository.save(existingProfile);
    }

    async remove(id: number): Promise<void> {
        const result = await this.userRepository.softDelete(id);

        if (result.affected === 0) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }
    }

    findByEmail(email: string): Promise<User> {
        return this.userRepository.findOneBy({email});
    }
}
