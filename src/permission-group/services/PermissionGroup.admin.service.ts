import { BadRequestException, Injectable, NotFoundException } from 'node_modules/@nestjs/common';
import { InjectRepository } from 'node_modules/@nestjs/typeorm';
import { Repository } from 'node_modules/typeorm';
import { PermissionGroup } from '../entities/PermissionGroup.entity';
import { PermissionGroupInputDto } from '../dtos/PermissionGroup.input.dto';

@Injectable()
export class PermissionGroupAdminService {

  constructor(
    @InjectRepository(PermissionGroup)
    private pgRepository: Repository<PermissionGroup>,
  ) { }

  async findById(idGroup: number): Promise<PermissionGroup> {
    const profile = await this.pgRepository
      .createQueryBuilder('permission_group')
      .where('permission_group.id = :id', { id: idGroup })
      .getOne();

    if (!profile) {
      throw new NotFoundException(
        `Permission with ID ${idGroup} not found`,
      );
    }

    return profile;
  }

  // async findById(id: number): Promise<PermissionGroup> {
  //   const permissions = await this.pgRepository
  //     .createQueryBuilder('permission_group')
  //     .where('permission_group.id = :id', { id: id })
  //     .getOne(); // Use getMany() to retrieve multiple permissions
  //
  //   return permissions;
  // }

  async createPermissionGroup(crGroupPermissionDto: PermissionGroupInputDto) {
    // try {
    return this.pgRepository.save(crGroupPermissionDto);
    // } catch(QueryFailedError){
    //   throw new BadRequestException("Role has been created")
    // }
  }


  async updateById(id: number, crGroupPermissionDto: PermissionGroupInputDto): Promise<PermissionGroup> {
    let role = crGroupPermissionDto.name;
    let groupPermission: PermissionGroup = await this.pgRepository
      .createQueryBuilder('group_permissions')
      .where('group_permissions.name = :name', { role })
      .getOne();
    // check role is present
    if (!groupPermission) {
      throw new BadRequestException('Role not found')
    }

    groupPermission.permissions = crGroupPermissionDto.permissions;
    return this.pgRepository.save(groupPermission);
  }

  async deleteGroup(id: number): Promise<string>{
    const result = await this.pgRepository
      .createQueryBuilder('permission_group')
      .delete()
      .where('permission_group.id = :id', { id })
      .execute();

    if (result.affected === 0) {
      return `Permission group with id '${id}' not found.`;
    }
    return `Permission group with id '${id}' successfully deleted.`;
  }


}

