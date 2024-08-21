import {Injectable, NotFoundException} from "@nestjs/common";
import {InjectRepository} from "@nestjs/typeorm";
import {Repository} from "typeorm";
import {User} from "../entities/User.entity";
import {UserResponseDto} from "../dtos/user.response.dto";
import {plainToClass} from "class-transformer";
import {CreateUserInputDto} from "../dtos/create-user.dto";
import * as bcrypt from "bcrypt";

@Injectable()
export class UsersAdminService {

  constructor(
      @InjectRepository(User)
      private userRepository: Repository<User>,
  ) { }

  async createNewUser(createUserInputDto: CreateUserInputDto) {
    
    const salt = await bcrypt.genSalt();
    createUserInputDto.password = await bcrypt.hash(createUserInputDto.password, salt);

    return this.userRepository.save(createUserInputDto);
  }

  // async findByPermissionGroupId(id: number): Promise<UserResponseDto[]> {
  //   let listProfile = await this.userRepository
  //     .createQueryBuilder('users')
  //       // .from(User, 'users')
  //     // .innerJoinAndSelect(PermissionGroup, 'PermissionGroup', 'PermissionGroup.id = users.permission_group_id')
  //     .where('users.permissionGroupId = :id', { id: id })
  //     .getMany();
  //
  //   if (!listProfile) {
  //     throw new NotFoundException(`User profile with ${id} role not found`);
  //   }
  //
  //   let response: UserResponseDto[] = [];
  //
  //   listProfile.forEach(p => {
  //     response.push(plainToClass(UserResponseDto, p, {
  //       excludeExtraneousValues: true,
  //       exposeUnsetFields: false,
  //     }))
  //   })
  //   return response;
  // }

  async findByPermissionGroupId(id: number): Promise<UserResponseDto[]> {
    const listProfile = await this.userRepository
        .createQueryBuilder('users')
        .where('users.permissionGroupId = :id', { id })
        .getMany();

    if (listProfile.length === 0) { // Updated to check for empty array
      throw new NotFoundException(`No users found for permission group id ${id}`);
    }

    return listProfile.map(p =>
        plainToClass(UserResponseDto, p, {
          excludeExtraneousValues: true,
          exposeUnsetFields: false,
        })
    );
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