import { BadRequestException, Injectable, NotFoundException } from 'node_modules/@nestjs/common';
import { InjectRepository } from 'node_modules/@nestjs/typeorm';
import { Repository } from 'node_modules/typeorm';
import { PermissionGroup } from '../entities/PermissionGroup.entity';
import { PermissionGroupInputDto } from '../dtos/PermissionGroup.input.dto';

@Injectable()
export class PermissionGroupService {

  constructor(
    @InjectRepository(PermissionGroup)
    private pgRepository: Repository<PermissionGroup>,
  ) { }

  async findById(idGroup: number): Promise<PermissionGroup> {
    const profile = await this.pgRepository
      .createQueryBuilder('permission_group')
      .where('permission_group.id = :id', { id: idGroup })
      .getOne();

    // .where('profile.roleId = 3', { roleId: 3 })
    // .andWhere('profile.id = :id', { id: userId })
    if (!profile) {
      throw new NotFoundException(
        `Permission with ID ${idGroup} not found`,
      );
    }

    return profile;
  }

  async findByRole(role: string): Promise<PermissionGroup> {
    const permissions = await this.pgRepository
      .createQueryBuilder('permission_group')
      .where('permission_group.role = :role', { role })
      .getOne(); // Use getMany() to retrieve multiple permissions

    return permissions;
  }

  async createWithNewRole(crGroupPermissionDto: PermissionGroupInputDto) {
    // try {
    return this.pgRepository.save(crGroupPermissionDto);
    // } catch(QueryFailedError){
    //   throw new BadRequestException("Role has been created")
    // }
  }


  async updateForRole(crGroupPermissionDto: PermissionGroupInputDto): Promise<PermissionGroup> {
    let role = crGroupPermissionDto.role;
    let groupPermission: PermissionGroup = await this.pgRepository
      .createQueryBuilder('group_permissions')
      .where('group_permissions.role = :role', { role })
      .getOne();
    // check role is present
    if (!groupPermission) {
      throw new BadRequestException('Role not found')
    }

    groupPermission.AccessControlSet = crGroupPermissionDto.AccessControlSet;
    return this.pgRepository.save(groupPermission);
  }

  async deleteGroup(role: string): Promise<void> {
    const result = await this.pgRepository
      .createQueryBuilder('permission_group')
      .delete()
      .where('permission_group.role = :role', { role })
      .execute();

    if (result.affected === 0) {
      throw new Error(`Permission group with role '${role}' not found.`);
    }
  }

}

