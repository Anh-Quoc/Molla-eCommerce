import { Injectable, NotFoundException } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { User } from "../entities/user.entity";
import { UserResponseDto } from "../dtos/user.response.dto";
import { plainToClass } from "class-transformer";
import { CreateUserInputDto } from "../dtos/create-user.dto";
import * as bcrypt from "bcrypt";

@Injectable()
export class UsersAdminService {
  async createNewUser(createUserInputDto: CreateUserInputDto) {
    
    const salt = await bcrypt.genSalt();
    let hashPassword = await bcrypt.hash(createUserInputDto.password, salt);
    createUserInputDto.password = hashPassword;

    return this.userRepository.save(createUserInputDto);
  }

  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) { }

  async findByRole(role: string): Promise<UserResponseDto[]> {
    let listProfile = await this.userRepository
      .createQueryBuilder('users')
      .leftJoinAndSelect('users.permissionGroup', 'PermissionGroup')
      .where('PermissionGroup.role =:role', { role: role })
      .getMany();

    // .where('profile.roleId = 3', { roleId: 3 })
    // .andWhere('profile.id = :id', { id: userId })
    if (!listProfile) {
      throw new NotFoundException(`User profile with ${role} role not found`);
    }

    let response: UserResponseDto[] = [];

    listProfile.forEach(p => {
      response.push(plainToClass(UserResponseDto, p, {
        excludeExtraneousValues: true,
        exposeUnsetFields: false,
      }))
    })
    return response;
  }

  async findById(userId: number): Promise<User> {
    const profile = await this.userRepository
      .createQueryBuilder('users')
      .where('users.id = :id', { id: userId })
      .getOne();

    // .where('profile.roleId = 3', { roleId: 3 })
    // .andWhere('profile.id = :id', { id: userId })
    if (!profile) {
      throw new NotFoundException(`User profile with ID ${userId} not found`);
    }

    return profile;
  }



}