import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { PermissionGroup } from "../entities/PermissionGroup.entity";

@Injectable()
export class PermissionGroupService {
  constructor(
    @InjectRepository(PermissionGroup)
    private permissionGroupRepository: Repository<PermissionGroup>,
  ) { }

  async findById(id: number): Promise<PermissionGroup>{

    return this.permissionGroupRepository
        .createQueryBuilder('permission_group')
        .where('permission_group.id = :id', {id})
        .getOne();
  }

  async getNamePermissionGroup(name: string): Promise<PermissionGroup> {
    return this.permissionGroupRepository.createQueryBuilder('permission_group')
        .where('permission_group.name = :name', {name})
        .getOne();
  }
  
}